class Sbjson < Formula
  desc "JSON CLI parser & reformatter based on SBJson v5"
  homepage "https://github.com/stig/json-framework"
  url "https://github.com/stig/json-framework/archive/v5.0.0.tar.gz"
  sha256 "e803753a157db475c4b89bddc0f550a5fdd0fc1980428a81ca6116feb2fd52e1"
  head "https://github.com/stig/json-framework.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "634ba12a265ba3f273d2b321dada0a1a9192f57fa9988c210d202445cc15a30c" => :mojave
    sha256 "c269d25dc05df3ee48da8f91f31a00c09b33ee1dfb135cec4783df44509f9478" => :high_sierra
    sha256 "aded461aca135b96288154c6fe6219d7c093a0836dafc6fdec90899256e8f8db" => :sierra
    sha256 "ce91cd42fb178216f3fe2ef6c617f9ca91a9e981b85142a22a8cc715ab105fc3" => :el_capitan
    sha256 "46f00ae266cdc64c839ff5ad2f8258eb42bdb7682e8e5201e9acb1f07f449611" => :yosemite
  end

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
    (testpath/"in.json").write <<~EOS
      [true,false,"string",42.001e3,[],{}]
    EOS

    (testpath/"unwrapped.json").write <<~EOS
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
