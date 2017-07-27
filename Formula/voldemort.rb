class Voldemort < Formula
  desc "Distributed key-value storage system"
  homepage "http://www.project-voldemort.com/"
  url "https://github.com/voldemort/voldemort/archive/release-1.10.25-cutoff.tar.gz"
  sha256 "d5e37d69cbe0cbb3605e0bf424bc2a5a4116fb81fedc481002341fd53cba8efb"

  bottle do
    cellar :any_skip_relocation
    sha256 "76ba2152aec4e7334fbffe43f9597b0c13aca9f039d69b6d44dcf6c162b017a0" => :sierra
    sha256 "272761b8757206fe1f31f7cc6b1ea36f7a6a804f6deb06ed14873eea6f894dfe" => :el_capitan
    sha256 "7364d98e346d5bb358f26674c19116c09b5b8e48e28651e90776307d6c4398fe" => :yosemite
  end

  depends_on "gradle" => :build
  depends_on :java => "1.7+"

  def install
    ENV.java_cache
    system "./gradlew", "build", "-x", "test"
    libexec.install %w[lib dist contrib]
    bin.install Dir["bin/*{.sh,.py}"]
    libexec.install "bin"
    pkgshare.install "config" => "config-examples"
    (etc/"voldemort").mkpath
    env = {
      :VOLDEMORT_HOME => libexec,
      :VOLDEMORT_CONFIG_DIR => etc/"voldemort",
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    system bin/"vadmin.sh"
  end
end
