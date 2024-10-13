class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.8.4.tar.gz"
  sha256 "2ad8c76f4226f508dc129fe1e4e6120a27b64b141bffe2c4c24d1f4dde2d0a69"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2afa762034ca0c4837adcd4613587c5db30540b6c3db04538cb7548743a4df8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "222627aa2010abc24797891842034559486876fb52626ef483f73eef791879af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "701dc123b9f089be94b9f4a26178e8b332e9a35269043cd157600d6a92e66147"
    sha256 cellar: :any_skip_relocation, sonoma:        "8083e48c330dff6e38fc9f64aa212189e65ffbb00b15daff4a7ac000ad34ab06"
    sha256 cellar: :any_skip_relocation, ventura:       "e399010676d3d25c34166587fecc054894513b1854c9e1d3bcc2c994e0536a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec9f547b3a9d59d2ee451bd982ad3102c846227cd8d250198ceb7a8d2ed1cd77"
  end

  depends_on "rust" => :build

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-run
      extensions/scarb-cairo-test
      extensions/scarb-snforge-test-collector
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "cairo-test"

    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system bin/"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath/"src/lib.cairo", :exist?
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb snforge-test-collector --version")
    assert_match version.to_s, shell_output("#{bin}/scarb doc --version")
  end
end
