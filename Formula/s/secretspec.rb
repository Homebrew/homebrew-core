class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "e2bc9cd215f7ddf74d7ef00bbe7cda318354a8223e7c04d7564759c70f3730b0"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0815a21230679e80de3cca652f5f43601afcfc7a7475323832fd3d728172b69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf9569aac906124e37c94dad60f94edcc7c7824eb7553edeff2f19fb576cce90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08c14f6a6807b2997605633ab2679b66a08ff4387f25c12c2f27665d542b00e8"
    sha256 cellar: :any,                 arm64_linux:       "272e1a023ca33c692ddc9c066206ca84402e6835b6f821d0215165ec16ce8103"
    sha256 cellar: :any,                 x86_64_linux:      "83e865ca2527e79f057cd1fbe540d6c2d0dc92396a808650442bcb50aab3c259"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
    generate_completions_from_executable(bin/"secretspec", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end
