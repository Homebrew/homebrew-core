class Xcprojectlint < Formula
  desc "Xcode project linter"
  homepage "https://github.com/americanexpress/xcprojectlint"
  url "https://github.com/americanexpress/xcprojectlint.git",
      tag:      "0.0.6",
      revision: "d9dad85847f5ee9b2143565a17d9066bb44b4b29"
  license "Apache-2.0"
  head "https://github.com/americanexpress/xcprojectlint.git"

  depends_on xcode: ["12.0", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    # Bad Xcode project
    (testpath/"Bad.xcodeproj/project.pbxproj").write <<~EOS
      {
        objects = {
          B4A1B4A825CF28FA00DF4293 = {isa = PBXGroup; children = (); sourceTree = "";};
          B4A1B4A925CF2DFF00DF4293 = {isa = PBXGroup; children = (B4A1B4A825CF28FA00DF4293); sourceTree = "";};
          B4A1B47B25CF0DD400DF4293 = {
            isa = PBXProject;
            buildConfigurationList = 0;
            compatibilityVersion = "";
            developmentRegion = en;
            hasScannedForEncodings = 0;
            knownRegions = (en);
            mainGroup = B4A1B4A925CF2DFF00DF4293;
            productRefGroup = B4A1B4A925CF2DFF00DF4293;
            projectDirPath = "";
            projectRoot = "";
            targets = ();
          };
        };
        rootObject = B4A1B47B25CF0DD400DF4293;
      }
    EOS
    output = shell_output("#{bin}/xcprojectlint --project Bad.xcodeproj --report error --validations all 2>&1", 70)
    assert_match "error: Xcode folder \“/B4A1B4A825CF28FA00DF4293\” has no children.", output

    # Good Xcode project
    (testpath/"Good.xcodeproj/project.pbxproj").write <<~EOS
      {
        objects = {
          B4A1B4A825CF28FA00DF4293 = {isa = PBXGroup; children = (); sourceTree = "";};
          B4A1B47B25CF0DD400DF4293 = {
            isa = PBXProject;
            buildConfigurationList = 0;
            compatibilityVersion = "";
            developmentRegion = en;
            hasScannedForEncodings = 0;
            knownRegions = (en);
            mainGroup = B4A1B4A825CF28FA00DF4293;
            productRefGroup = B4A1B4A825CF28FA00DF4293;
            projectDirPath = "";
            projectRoot = "";
            targets = ();
          };
        };
        rootObject = B4A1B47B25CF0DD400DF4293;
      }
    EOS
    assert_empty shell_output("#{bin}/xcprojectlint --project Good.xcodeproj --report error --validations all 2>&1")
  end
end
