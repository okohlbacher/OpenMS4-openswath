cask "openms4-openswath" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.7,5a3c9e37711d"
  sha256 arm:   "02e66763310d7ebf921774e078f5ba031c6926caffc496ca0d995f96cc76a019",
         intel: "644ac69c3efed5852c4da8ea0b04a47322cb34a33c894c1562951439a907d5ca"

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
    next if core == "83ce20da78337b0b329f5c634e52226585e4788d"

    raise Cask::CaskError, "openms4-openswath #{version.csv.first} was built against openms4-core 83ce20da7833, " \
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
