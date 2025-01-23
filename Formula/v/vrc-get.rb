class VrcGet < Formula
  desc "Open Source alternative of Command-line client of VRChat Package Manager"
  homepage "https://github.com/vrc-get/vrc-get"
  url "https://github.com/vrc-get/vrc-get/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "4d3821eb4047f7ee83a07a589e97a63608680a71200046d571f9db3320bf8d65"
  license "MIT"
  head "https://github.com/vrc-get/vrc-get.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fe8c69965afb8677e2976c2bd01969d83fb94cfc39ca6ebd2353621ed433bba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4187e7a323417acaa1d1c6da1b4493d1e56d2c3b4c1cf7a6e625420121c3c90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42fab214e3b40da97fe5368b838a1a03b5c534574d0ee1894869dd2819717ca6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d611cd64afa6c1b8a76a0ecc52a2fdaf1ed514ca13b35d28950bbc7f45337b3d"
    sha256 cellar: :any_skip_relocation, ventura:       "6a8ac8b21c07dc4ef748b0365388463f481b765e60c9492a611e996f17aef78e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf27fd9ca3c93fe01e9db091775dec6c2a6c48c03e79ee90b23ed8b8fc2f03da"
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
