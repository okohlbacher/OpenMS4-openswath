cask "openms4-openswath" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.3,2ac1cca68c65"
  sha256 arm:   "7ea8efa7f6f026d2efafbf8860de55a1199ce84e74488fd23308656c9ab541be",
         intel: "dec40ab7738571e1c0239d9c7d6fe9568f1585b94fe1b8a29261630f6e2aa20a"

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
    next if core == "ac41cc177023e24a8fbc711a6ce9010187c54c44"

    raise Cask::CaskError, "openms4-openswath #{version.csv.first} was built against openms4-core ac41cc177023, " \
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
