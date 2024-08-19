class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "8dcea331acc23e38d7b787fc4361d26a73bc54dfb035eba41f451d4199817b55"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bebe89d28af9d82716788e2a1532d71a5c7f3a6518b80d1a82b293d395359e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22edae4bcd8e226a3782579c64a7a2d3551900ba06e4c86e8a50fef7b2137030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd282d48a8b317f90b67c1d46c25d316b9de38331634b0ed4d93543d6ff026f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "50e7c42c77658a55fdcfc7cfe94c1c90a412a126029e562a773107ad7f26cec9"
    sha256 cellar: :any_skip_relocation, ventura:        "5004a309417fbe94a126ecb7a4ca483f2b488e5b323fda77743cc5fef92c4467"
    sha256 cellar: :any_skip_relocation, monterey:       "6036996bf8cbae60626572a8b685b4bc1a660148586b01bfdabdc94ef20868d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56e73110a9d0baf9f5148e42784ad530374edcabb1158a8aefeefcccee876e7f"
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
