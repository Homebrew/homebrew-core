class Um < Formula
  desc "Command-line utility for creating and maintaining personal man pages"
  homepage "https://github.com/sinclairtarget/um"
  url "https://github.com/sinclairtarget/um/archive/4.1.0.tar.gz"
  sha256 "0606cd8da69618d508d06dee859dd1147a4d8846cdff57fb8958c71fe906523f"

  bottle :unneeded
  depends_on "ruby"

  resource "kramdown" do
    url "https://rubygems.org/gems/kramdown-1.17.0.gem"
    sha256 "5862410a2c1692fde2fcc86d78d2265777c22bd101f11c76442f1698ab242cd8"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resource("kramdown").stage do |context|
      system("gem", "install", context.resource.cached_download,
             "--no-document", "--install-dir", libexec)
    end

    system "gem", "build", "um.gemspec"
    system "gem", "install", "--ignore-dependencies", "um-#{version}.gem"

    bin.install libexec/"bin/um"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])

    bash_completion.install "um-completion.sh"
    man1.install Dir["doc/man1/*"]
  end

  test do
    shell_output("#{bin}/um version")
  end
end
