class Sbjson < Formula
  desc "JSON CLI parser & reformatter based on SBJson v5"
  homepage "https://github.com/stig/json-framework"
  url "https://github.com/stig/json-framework/archive/v5.0.0.tar.gz"
  sha256 "e803753a157db475c4b89bddc0f550a5fdd0fc1980428a81ca6116feb2fd52e1"

  head "https://github.com/stig/json-framework.git"

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "SBJson5.xcodeproj",
               "-target", "sbjson",
               "-configuration", "Release",
               "clean",
               "build",
               "SYMROOT=build"

    bin.install "build/Release/sbjson"
  end

  test do
    (testpath/"in.json").write <<-EOS.undent
      [true,false,"string",42.001e3,[],{}]
    EOS

    (testpath/"unwrapped.json").write <<-EOS.undent
      true
      false
      "string"
      42001
      []
      {}
    EOS

    assert_equal shell_output("cat unwrapped.json"),
                 shell_output("#{bin}/sbjson --unwrap-root in.json")
  end
end
