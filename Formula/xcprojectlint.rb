class Xcprojectlint < Formula
  desc "Xcode project linter"
  homepage "https://github.com/americanexpress/xcprojectlint"
  url "https://github.com/americanexpress/xcprojectlint.git", tag: "0.0.6", revision: "d9dad85847f5ee9b2143565a17d9066bb44b4b29"
  license "Apache-2.0"
  head "https://github.com/americanexpress/xcprojectlint.git"

  depends_on xcode: ["12.0", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    # Bad Xcode project
    (testpath/"Bad.xcodeproj/project.pbxproj").write <<~EOS
      // !$*UTF8*$!
      {
              objects = {
      /* Begin PBXBuildFile section */
                      B4A1B48725CF0DD400DF4293 /* B in Sources */ = {isa = PBXBuildFile; fileRef = B4A1B48625CF0DD400DF4293 /* B */; };
                      B4A1B48925CF0DD400DF4293 /* A in Sources */ = {isa = PBXBuildFile; fileRef = B4A1B48825CF0DD400DF4293 /* A */; };
      /* End PBXBuildFile section */
      /* Begin PBXFileReference section */
                      B4A1B48625CF0DD400DF4293 /* B */ = {isa = PBXFileReference; lastKnownFileType = text; path = B; sourceTree = "<group>"; };
                      B4A1B48825CF0DD400DF4293 /* A */ = {isa = PBXFileReference; lastKnownFileType = text; path = A; sourceTree = "<group>"; };
                      B4A1B49925CF0E2B00DF4293 /* Test.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; name = Test.app; path = "Test.app"; sourceTree = "<group>"; };
      /* End PBXFileReference section */
      /* Begin PBXGroup section */
                      B4A1B47A25CF0DD400DF4293 = {
                              isa = PBXGroup;
                              children = (
                                      B4A1B48525CF0DD400DF4293 /* X */,
                              );
                              sourceTree = "<group>";
                      };
                      B4A1B48525CF0DD400DF4293 /* X */ = {
                              isa = PBXGroup;
                              children = (
                                      B4A1B48625CF0DD400DF4293 /* B */,
                                      B4A1B48825CF0DD400DF4293 /* A */,
                              );
                              path = X;
                              sourceTree = "<group>";
                      };
      /* End PBXGroup section */
      /* Begin PBXProject section */
                      B4A1B47B25CF0DD400DF4293 /* Project object */ = {
                              isa = PBXProject;
                              buildConfigurationList = B4A1B47E25CF0DD400DF4293 /* Build configuration list for PBXProject "Test" */;
                              compatibilityVersion = "Xcode 9.3";
                              developmentRegion = en;
                              hasScannedForEncodings = 0;
                              knownRegions = (Base);
                              mainGroup = B4A1B47A25CF0DD400DF4293;
                              productRefGroup = B4A1B47A25CF0DD400DF4293;
                              projectDirPath = "";
                              projectRoot = "";
                              targets = (B4A1B48225CF0DD400DF4293 /* Test */);
                      };
      /* End PBXProject section */
              };
              rootObject = B4A1B47B25CF0DD400DF4293 /* Project object */;
      }
    EOS
    output = shell_output("#{bin}/xcprojectlint --project Bad.xcodeproj --report error --validations all 2>&1", 70)
    assert_match "error: Xcode folder \“/X\” has out-of-order children.", output
    assert_match "Expected: [\"A\", \"B\"]", output
    assert_match "Actual:   [\"B\", \"A\"]", output

    # Good Xcode project
    (testpath/"Good.xcodeproj/project.pbxproj").write <<~EOS
      // !$*UTF8*$!
      {
              objects = {
      /* Begin PBXGroup section */
                      B4AE8FA725CEE83D00043E9E = { isa = PBXGroup; children = (); sourceTree = "<group>"; };
      /* End PBXGroup section */
      /* Begin PBXProject section */
                      B4AE8FA825CEE83D00043E9E /* Project object */ = {
                              isa = PBXProject;
                              buildConfigurationList = B4AE8FAB25CEE83D00043E9E /* Build configuration list for PBXProject "Test" */;
                              compatibilityVersion = "Xcode 9.3";
                              developmentRegion = en;
                              hasScannedForEncodings = 0;
                              knownRegions = (Base);
                              mainGroup = B4AE8FA725CEE83D00043E9E;
                              productRefGroup = B4AE8FA725CEE83D00043E9E;
                              projectDirPath = "";
                              projectRoot = "";
                              targets = ();
                      };
      /* End PBXProject section */
              };
              rootObject = B4AE8FA825CEE83D00043E9E /* Project object */;
      }
    EOS
    assert_empty shell_output("#{bin}/xcprojectlint --project Good.xcodeproj --report error --validations all 2>&1")
  end
end
