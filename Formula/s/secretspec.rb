class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "007ae4422ad59c2d2e12046db84311f098a53dc4327a51165ed26cb4db61be70"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e7b48171f0c7eb663eabb92e313bfd3d2755fbaf0621a906a68f28eb56f7a63"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "af51e366858b7558268657047ad16f4efb3e61d1fdac6f2014eba3ef3427c540"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f576b04ae1d40baef2b13a3a3b51ae3da9b9688420e38d9917dba6b5b8d2bdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e08247f111b4410728fdb5135be34d425efbaa85aeb477ad3590dbeb3b3a3dd9"
    sha256 cellar: :any,                 arm64_linux:       "84e12d303cd944b923d79327046d1114c299fd238bf502ed75a02cc79f457da9"
    sha256 cellar: :any,                 x86_64_linux:      "eddd528df6af573ebc84ae6286dd6e1e8131734f3b53ae4db98ac14b3d9ed5f9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end
