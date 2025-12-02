class RonnNg < Formula
  desc "Build man pages from Markdown"
  homepage "https://github.com/apjanke/ronn-ng"
  url "https://github.com/apjanke/ronn-ng/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "180f18015ce01be1d10c24e13414134363d56f9efb741fda460358bb67d96684"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95544c3a98367e90154643f7ba9a8f1294be476483e7f2faa32a65344ed23cb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d39afaff29b90a17336c9033eb12d405f5b8c29c7e804872a87281c889d84d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d39afaff29b90a17336c9033eb12d405f5b8c29c7e804872a87281c889d84d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d39afaff29b90a17336c9033eb12d405f5b8c29c7e804872a87281c889d84d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0d1bcdca16b8ce2b8641e8224a374ebe25cb744721c84047cd101e505e07f72"
    sha256 cellar: :any_skip_relocation, ventura:       "f0d1bcdca16b8ce2b8641e8224a374ebe25cb744721c84047cd101e505e07f72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d588a927ed953cb8901d41ab8af46b413fefc011d12e1e9c8aeabc23d582e35f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b303b18ed67bc5b328597d421c4a2c0449a5e65372706b04ed58f0f9319d10e"
  end

  # Nokogiri 1.9 requires a newer Ruby
  depends_on "ruby"

  conflicts_with "ronn", because: "both install `ronn` binaries"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "ronn-ng.gemspec"
    system "gem", "install", "ronn-ng-#{version}.gem"
    bin.install libexec/"bin/ronn"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    bash_completion.install "completion/bash/ronn"
    zsh_completion.install "completion/zsh/_ronn"
    man1.install Dir["man/*.1"]
    man7.install Dir["man/*.7"]
  end

  test do
    (testpath/"test.ronn").write <<~MARKDOWN
      helloworld
      ==========

      Hello, world!
    MARKDOWN

    assert_match "Hello, world", shell_output("#{bin}/ronn --roff --pipe test.ronn")
  end
end
