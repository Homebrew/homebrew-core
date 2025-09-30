class Rem < Formula
  desc "Command-line tool to access OSX Reminders.app database"
  homepage "https://github.com/kykim/rem"
  url "https://github.com/kykim/rem/archive/refs/tags/20150618.tar.gz"
  sha256 "e57173a26d2071692d72f3374e36444ad0b294c1284e3b28706ff3dbe38ce8af"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3f0f26a3c93f78baac169c18c7fa119e351fdb10d8cce429fae0f45942676775"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "18d24b6a8f332bb30a204b078ae06569a7fc851895aea755e5c3771a24b60ddd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bda72308d8fd433628ebefa28e3821f2a6be7544ae2e358d09be602b8bf8f9da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83fa3cbc561ea006d86be97f4e6b4d23dd3368a027e5caabd0966da44f545100"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95518f0764af3fbec9cede76e6431255c13360bf5d78c1f7447c16f6ff79ab81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0f72e190a73fd43f3528c08049aca2f52ce7a8cfa25b779383c3692ee7aab18"
    sha256 cellar: :any_skip_relocation, sonoma:         "03e3eae7390b3b17b2bc20c3f13c9bb2f5bd5f5efca57d7d63009b1c9d05900c"
    sha256 cellar: :any_skip_relocation, ventura:        "fefae56adda2dc6449fa9739305bb1915fa3bb4dc08c530cb0ce98aa0cb3e306"
    sha256 cellar: :any_skip_relocation, monterey:       "f3d0ceb432ecfde1ef59ac1bedc77b072b02a64b6013fb2606d278ec2d3ee4df"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0af2d48a7809890f04480b0b4d28f6354130754609627ed76ce6d76a5135898"
    sha256 cellar: :any_skip_relocation, catalina:       "bfab3fd2fd8da4e4620d80a632d774b4742c6c34c5b73d89fafd3d246369fce6"
  end

  depends_on xcode: :build
  depends_on :macos

  conflicts_with "remind", because: "both install `rem` binaries"

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}",
               "SYMROOT=build"
    bin.install "build/Release/rem"
  end

  test do
    system bin/"rem", "version"
  end
end
