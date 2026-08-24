class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "c831a0072af7b51d11931d3f1444a13313cb63eae515df609c1e3d72356ba497"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a15850ebec29dc91b8f0c1ebff43fdae4d2f71cfbfeafc030c2f2affc314122"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fddadfeb6dfb07f2ddd51d572807f9af0aae56058837a0e11c8c142ca8a8f1b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94d92ed09e67f3777ca24cdcf7bb760e79c58cea8c202ba71e4dc20c665fe03f"
    sha256 cellar: :any_skip_relocation, sonoma:        "814ded71ad8a8a2e36269878e84ada5b97b4f9aab2e5136df9443d7654427c56"
    sha256 cellar: :any,                 arm64_linux:   "feec51f31d09e0529db491d0e5c8557fe58048f54c2a723cd0693b929b5061f3"
    sha256 cellar: :any,                 x86_64_linux:  "6205b7198ca377d73b5ea08625885c85039b4b37e9f59938d4a662a16bd57e85"
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
