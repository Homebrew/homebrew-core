class Sbjson < Formula
  desc "JSON CLI parser & reformatter based on SBJson v5"
  homepage "https://github.com/stig/json-framework"
  url "https://github.com/stig/json-framework/archive/v5.0.3.tar.gz"
  sha256 "9a03f6643b42a82300f4aefcfb6baf46cc2c519f1bb7db3028f338d6d1c56f1b"
  head "https://github.com/stig/json-framework.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae17cd9f58361f2a482bdffe5aee76da5cf34131ba14ea6b3aa1cea2f348e852" => :catalina
    sha256 "239b7bb8278f310fb76feb7dc3be64cf5c05720bdf7655c915d27b90c7761c38" => :mojave
    sha256 "ce4947b43a5706b19e1ac8f0b42234bbad19d033d5344afd72cfb9ae5470f52a" => :high_sierra
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
