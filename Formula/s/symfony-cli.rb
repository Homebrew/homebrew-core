class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://github.com/symfony-cli/symfony-cli"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.16.0.tar.gz"
  sha256 "50573dea965e33961e21737350386256f7f962316cdfbc6776572d369afad490"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bce2725d72888a4da22b50dc1609301d66071c4f537897a08e8613e175cc4779"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1618b3e185e4fcc0cd6d9d10383dfbeb729f498fe30e6d878007e9c4c3c5214"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1217405756a4fda9263891629761fc6d64c10cc2354f6d00e30396f01d2973c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a00c2e49ae217f0d42124569e7dc997404730c8fe09a331f1ad959adc5c78d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "184d0eed446dbb9a950aba5ba0a1b14f2007658cf1bb81f5ed460e12f0289f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5bc1d4dd372176fbff3af2ffe0595a1aa5187b168b3661bd4ecc600529aaa99"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.channel=stable", output: bin/"symfony")
  end

  test do
    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
    output = shell_output("#{bin}/symfony -V")
    assert_match version.to_s, output
    assert_match "stable", output
  end
end
