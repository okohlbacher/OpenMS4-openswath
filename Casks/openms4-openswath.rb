cask "openms4-openswath" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.8,1c6556fde80e"
  sha256 arm:   "c0ea92b47cfa66aff338a20696ccb0e759daae44eb1d87a24ca8ec74f5b64286",
         intel: "e5616b3eb490ea28edb9d3f0877c722ecac36d0488ed6ffec67213362eb3322b"

  url "https://github.com/okohlbacher/OpenMS4-openswath/releases/download/" \
      "openswath-v#{version.csv.first}/OpenMS4-openswath-macos-#{arch}-Homebrew-#{version.csv.second}.tar.gz"
  name "OpenMS 4 openswath tools"
  desc "Command-line mass-spectrometry tools built against the OpenMS Core SDK"
  homepage "https://github.com/okohlbacher/OpenMS4-openswath"

  depends_on formula: "okohlbacher/openms4-core/openms4-core"
  depends_on macos: :sequoia

  payload = "OpenMS4-openswath-macos-#{arch}-Homebrew-#{version.csv.second}"
  binary "#{payload}/bin/MRMTransitionGroupPicker"
  binary "#{payload}/bin/OpenSwathAnalyzer"
  binary "#{payload}/bin/OpenSwathAssayGenerator"
  binary "#{payload}/bin/OpenSwathChromatogramExtractor"
  binary "#{payload}/bin/OpenSwathConfidenceScoring"
  binary "#{payload}/bin/OpenSwathDIAPreScoring"
  binary "#{payload}/bin/OpenSwathDecoyGenerator"
  binary "#{payload}/bin/OpenSwathExport"
  binary "#{payload}/bin/OpenSwathFeatureXMLToTSV"
  binary "#{payload}/bin/OpenSwathFileSplitter"
  binary "#{payload}/bin/OpenSwathInfer"
  binary "#{payload}/bin/OpenSwathMzMLFileCacher"
  binary "#{payload}/bin/OpenSwathPeakMapExtractor"
  binary "#{payload}/bin/OpenSwathPercolatorScoring"
  binary "#{payload}/bin/OpenSwathRTNormalizer"
  binary "#{payload}/bin/OpenSwathRewriteToFeatureXML"
  binary "#{payload}/bin/OpenSwathWorkflow"
  binary "#{payload}/bin/TargetedFileConverter"
  binary "#{payload}/bin/TransitionListEvidenceFilter"

  # libOpenMS has no versioned name, so a payload only runs with the Core it was built against.
  preflight do
    config = "#{HOMEBREW_PREFIX}/opt/openms4-core/lib/cmake/OpenMS/OpenMSConfig.cmake"
    core = File.exist?(config) ? File.read(config)[/set\(OpenMS_SOURCE_REVISION "([0-9a-f]{40})"\)/, 1] : nil
    next if core == "0529ec8bfe0785d546dab56f58456525ef0fef02"

    raise Cask::CaskError, "openms4-openswath #{version.csv.first} was built against openms4-core 0529ec8bfe07, " \
                           "but the installed openms4-core is #{core&.slice(0, 12) || "unknown"}. " \
                           "Install the openms4-openswath release built for the installed Core."
  end

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "."],
        chdir:          ".",
        writable_paths: ["."]
  end
end
