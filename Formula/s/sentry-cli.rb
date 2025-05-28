class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.46.0.tar.gz"
  sha256 "eb7ab4f8ea6338582baf9335fef5d9e5340f918e8ac41116f9f83559b7c4d344"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7da89ac606667a40338012b27cf303f4f9c4354752386ad5d2eb55596ff574cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81a2c48146be930e3afff6163c4bec471076645d66a14d837832012e6d428db4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a511db75c5b7cc7a4b3fae779cd1e00b33555b4a973c113ab63c46bb45621979"
    sha256 cellar: :any_skip_relocation, sonoma:        "4006029304324cf229de6b674ae287ccc5f51cae7d938eea730c8599b808edfa"
    sha256 cellar: :any_skip_relocation, ventura:       "4b8ea2d4efc000e1f21626ce1ce23519b6376e5704c769d479319c773d25724b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2ce7bab6e424741909ba67d7d6e2d6d4b347fdce8f114dff77c49c55a7d66f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e11439501e145c7bdd4af4abb3827e18da777f07df9e4f9abe25b8230b2e07b6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sentry-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sentry-cli --version")

    output = shell_output("#{bin}/sentry-cli info 2>&1", 1)
    assert_match "Sentry Server: https://sentry.io", output
    assert_match "Auth token is required for this request.", output
  end
end
