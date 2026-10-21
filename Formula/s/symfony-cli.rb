class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://symfony.com/download"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.22.2.tar.gz"
  sha256 "5cb2eb468eb90501519395d24f2023ed19cb1b49299124eeba2516335b2510d2"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "96bb73a33cf279f6c8734342fe6d047af493746588d5bfe37a4daca70bdd4e40"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a36571f929d474bad26030f7a7fce91e64fbeb10ba7f40daa84b018800af8071"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "daa78f84937229bd0463b8fc693be376ef3c79c6274695a6742977da09293e91"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ceb9022b5b7336b6c1bb9464ad141525687c9718a4ef67feddab4f4f0f2c2b01"
    sha256 cellar: :any,                 x86_64_linux:      "752a073a8f993cd0030217b6f9a75ab1bb93a54230a7b1526b68daa0733854a7"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.buildDate=#{time.iso8601}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"symfony")

    generate_completions_from_executable(bin/"symfony", "self:completion")
  end

  service do
    run ["#{opt_bin}/symfony", "local:proxy:start", "--foreground"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/symfony self:version")

    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
  end
end
