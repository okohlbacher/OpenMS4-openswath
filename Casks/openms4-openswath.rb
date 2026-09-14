cask "openms4-openswath" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.2,851e8f0e0ec4"
  sha256 arm:   "d609ba1f5abbdfdd7ba897edb78bbe933f3f3309332efeb60da6bc0365aeaff2",
         intel: "fd1ae65cadbf03a7b421380b580ce2bb305c074f0235bcd62f4dd0f0f3f16ed0"

  url "https://github.com/okohlbacher/OpenMS4-openswath/releases/download/" \
      "openswath-v#{version.csv.first}/OpenMS4-openswath-macos-#{arch}-Homebrew-#{version.csv.second}.tar.gz"
  name "OpenMS 4 openswath tools"
  desc "Command-line mass-spectrometry tools built against the OpenMS Core SDK"
  homepage "https://github.com/okohlbacher/OpenMS4-openswath"

  disable! date:    "2026-09-14",
           because: "was built against openms4-core 4.0.0-ci.2, and the tap now serves a binary-incompatible newer Core"

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

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "."],
        chdir:          ".",
        writable_paths: ["."]
  end
end
