class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://symfony.com/download"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.20.0.tar.gz"
  sha256 "07e528495409a1ba147a7a3905086f50c629762c60d186547d5483148e7a2cc2"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d658560d40f3930ad574474093cf00e2950f527a24a0e40acead26c8fd183d97"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a6ea35d3bab3d4e19d2c5c5b63f7cd2c2eee406443b334bd02b84b1cbfe37b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d54c29c835761895c4dfada3b62d7c275416c625791bd28787cf2a87e2ba1e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "423e0ab008485c6c4c699f3290ce45b97b2ed510534053f89034ddf1b5f894e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "54df7c542a8ffcae55de7196e04ff741dc5a3f83e0653ec0813a79b7307534c9"
    sha256 cellar: :any,                 x86_64_linux:      "158e4fae43aac84cf45592e575f0e6277eb551b3ffa5f09bc7ce2845d2dd2b46"
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
