class Rem < Formula
  desc "Command-line tool to access OSX Reminders.app database"
  homepage "https://github.com/kykim/rem"
  url "https://github.com/kykim/rem/archive/20150618.tar.gz"
  sha256 "e57173a26d2071692d72f3374e36444ad0b294c1284e3b28706ff3dbe38ce8af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95518f0764af3fbec9cede76e6431255c13360bf5d78c1f7447c16f6ff79ab81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0f72e190a73fd43f3528c08049aca2f52ce7a8cfa25b779383c3692ee7aab18"
    sha256 cellar: :any_skip_relocation, monterey:       "f3d0ceb432ecfde1ef59ac1bedc77b072b02a64b6013fb2606d278ec2d3ee4df"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0af2d48a7809890f04480b0b4d28f6354130754609627ed76ce6d76a5135898"
    sha256 cellar: :any_skip_relocation, catalina:       "bfab3fd2fd8da4e4620d80a632d774b4742c6c34c5b73d89fafd3d246369fce6"
    sha256 cellar: :any_skip_relocation, mojave:         "4226be6dc999a4467a061055cb36a68babe84a835f40f32a5a23f6137ddd59b4"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0a3365c8653023f2b4de8c5b6243aec2de7c180d1be982adcdbe58afc159800e"
    sha256 cellar: :any_skip_relocation, sierra:         "326f7a21f696b7614a55a5edeb57e08482ff7b4c72506bcecff5deaa0552828e"
    sha256 cellar: :any_skip_relocation, el_capitan:     "c9892df4f6aa5d58097e4cc4d62388ccbb1e0c02604b1139cfe829d47d992442"
    sha256 cellar: :any_skip_relocation, yosemite:       "d9a6303ff3935923ba53d093e95387caaf24460a4cd7fb7d330fa5c3988b551c"
  end

  depends_on xcode: :build
  depends_on :macos

  conflicts_with "remind", because: "both install `rem` binaries"

  def install
    xcodebuild "-arch", Hardware::CPU.arch, "SYMROOT=build"
    bin.install "build/Release/rem"
  end

  test do
    system "#{bin}/rem", "version"
  end
end
