class VrcGet < Formula
  desc "Open Source alternative of Command-line client of VRChat Package Manager"
  homepage "https://github.com/vrc-get/vrc-get"
  url "https://github.com/vrc-get/vrc-get/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "79157a0dc592837aca541b1b85a2fab4eb86e0becbc28282459b2d60a6097144"
  license "MIT"
  head "https://github.com/vrc-get/vrc-get.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b3232d3572872e80a6ca8c2dd040a5102a498ec05441ec62eb6d6ad7e1e84d3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dca7679227d0a18cca706624960922789ea83367097430a577d9db983e874194"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "912d0e25b3f056bf6295e6202603f3441f093770a93432474ace49040bf8af2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca36790160878f1227cee2c2dfc9691d7a60e0d12678fded6ee86baca67f0759"
    sha256 cellar: :any_skip_relocation, sonoma:         "e33c646e105e706e06e8e3d9cd1c9549f950729ce6b527b54106aa3cc2e38866"
    sha256 cellar: :any_skip_relocation, ventura:        "fb13b69dd5534810a76adb5ee2f10c69496d01cbbd1d0ecf310abd45bdc64fc3"
    sha256 cellar: :any_skip_relocation, monterey:       "c7706dd968693ce092fd280b86a7cb730d7da4c86f4e6ca4377f66d64e2d81ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a20bc378fe730a06171ae0f90f55d2af25547c58d2c2594b11e4f9c94f2c9fbd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "vrc-get")
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath/"data-home"
    system bin/"vrc-get", "update"
    assert_predicate testpath/"data-home/VRChatCreatorCompanion/Repos/vrc-official.json", :exist?
  end
end
