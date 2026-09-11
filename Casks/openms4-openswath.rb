cask "openms4-openswath" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.1,047ba961bf81"
  sha256 arm:   "9d1bd9f6caa7f98fe2c739dad65d6c1def1428cbca191228a844082c263a8f60",
         intel: "062e94caa2417a831fd3c296f808a882e26f1ccb8dca117ca85904fbeec01135"

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

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "."],
        chdir:          ".",
        writable_paths: ["."]
  end
end
