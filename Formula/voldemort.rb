class Voldemort < Formula
  desc "Distributed key-value storage system"
  homepage "http://www.project-voldemort.com/"
  url "https://github.com/voldemort/voldemort/archive/release-1.10.24-cutoff.tar.gz"
  sha256 "b4dcdba4f17d86517a4af9d8ec4bff27a4e489f379557961fedbb02537464fa8"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d4fe894dafb965550b30e1ab8bbbfed1019fb33be830db3779b596d13212ad4" => :sierra
    sha256 "fa17ebb844d76054267dba56931e4434328f3c69c1feae1c1f259cf16368baf7" => :el_capitan
    sha256 "992c7ff4c25d8374de15c28b95cefc2b8f14c28d0d30bd68bc92f342f7c6f7bb" => :yosemite
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
