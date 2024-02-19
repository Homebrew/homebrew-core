class Sugarjar < Formula
  desc "Helper utility for a better Git/GitHub experience"
  homepage "https://github.com/jaymzh/sugarjar/"
  url "https://github.com/jaymzh/sugarjar/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "27dcadee28327585cf26d1285a0a4806352c3d118131d9efde3729d7956510bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51ceb3601cac4b1a6ac1338c6f2e0cb024c3ddef5a657776a03f5de5b8563e3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51ceb3601cac4b1a6ac1338c6f2e0cb024c3ddef5a657776a03f5de5b8563e3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51ceb3601cac4b1a6ac1338c6f2e0cb024c3ddef5a657776a03f5de5b8563e3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0920b193345a8e79ea4a6bb13da27be533bf32a9a8a025d1d611e1bfe0e8ce57"
    sha256 cellar: :any_skip_relocation, ventura:        "0920b193345a8e79ea4a6bb13da27be533bf32a9a8a025d1d611e1bfe0e8ce57"
    sha256 cellar: :any_skip_relocation, monterey:       "0920b193345a8e79ea4a6bb13da27be533bf32a9a8a025d1d611e1bfe0e8ce57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51ceb3601cac4b1a6ac1338c6f2e0cb024c3ddef5a657776a03f5de5b8563e3b"
  end

  depends_on "gh"
  # Requires Ruby >= 3.0
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "sugarjar.gemspec"
    system "gem", "install", "--ignore-dependencies", "sugarjar-#{version}.gem"
    bin.install libexec/"bin/sj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    bash_completion.install "extras/sugarjar_completion.bash"
  end

  test do
    output = shell_output("#{bin}/sj lint", 1)
    assert_match "sugarjar must be run from inside a git repo", output
    output = shell_output("#{bin}/sj bclean", 1)
    assert_match "sugarjar must be run from inside a git repo", output
  end
end
