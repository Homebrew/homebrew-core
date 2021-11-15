class Xcprojectlint < Formula
  desc "Xcode project linter"
  homepage "https://github.com/americanexpress/xcprojectlint"
  url "https://github.com/americanexpress/xcprojectlint.git",
      tag:      "0.0.6",
      revision: "d9dad85847f5ee9b2143565a17d9066bb44b4b29"
  license "Apache-2.0"
  head "https://github.com/americanexpress/xcprojectlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c5233bd7427141a2a3aaac3979661ececab9babacc18b4b4af258f45a87f5ef6"
    sha256 cellar: :any_skip_relocation, big_sur:       "82e41371144c071dc8cb360cc434d2e692ced87a38f90d41e8422f64425263af"
    sha256 cellar: :any_skip_relocation, catalina:      "e573329068894a330ee859bdc2968001d42b2d06005824ca7a099d52e2dda543"
  end

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
