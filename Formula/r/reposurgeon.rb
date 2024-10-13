class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/5.1/reposurgeon-5.1.tar.gz"
  sha256 "8c0096abd9204e8756c1a661f940d78046aec813f0870a1c4ca267ae8889195a"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "083cd6e487499c5f3c201d91e89bc93a188d0ef65d3dff7a79705662faec3a84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbddc935da21f1d9771abcc8c19c9cafeb89c72c59bdb9cd21dd4cda80969ce5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "168eec439d7e10f1c8b48cdbcbb7f391f00d1bb5bdf3f1d50658dbafb90cbcc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84fd6f0ce024e99d9af67d0a4b1eba87d6aea997c43dd4fd863f84b98ec095ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "63ec663228e032b4ac29d9c2988ae74bc1125ce4812988ccf88cece3d0a2937a"
    sha256 cellar: :any_skip_relocation, ventura:        "b81f792d6fff0f9f40519a69eabe48f5a7a5afbc25796d1b6031dbaa159393e7"
    sha256 cellar: :any_skip_relocation, monterey:       "280ac9d2c563dbf391d981f65b48c992a10fe04bb81cbcee8a2e84f0babd823e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e2c0aa069a8707eeee353032eb6fa1beede0b2ef0cdecd9ab4584eab7f92d33"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "git" # requires >= 2.19.2

  uses_from_macos "ruby"

  on_system :linux, macos: :catalina_or_older do
    depends_on "gawk" => :build
  end

  def install
    ENV.append_path "GEM_PATH", Formula["asciidoctor"].opt_libexec
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
    elisp.install "reposurgeon-mode.el"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    assert_match "brewing",
      shell_output("#{bin}/reposurgeon read list")
  end
end
