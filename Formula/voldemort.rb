class Voldemort < Formula
  desc "Distributed key-value storage system"
  homepage "http://www.project-voldemort.com/"
  url "https://github.com/voldemort/voldemort/archive/release-1.10.24-cutoff.tar.gz"
  sha256 "b4dcdba4f17d86517a4af9d8ec4bff27a4e489f379557961fedbb02537464fa8"

  bottle do
    cellar :any_skip_relocation
    sha256 "41f36e0d347191ca716ff5f7a0198cc38c71955ba47fa3f4a4f10848ebe90109" => :sierra
    sha256 "f8329c6366b5a657ba17f24868b867a6647f6050aa9556890ab75cfb5676616f" => :el_capitan
    sha256 "923f3e8a556148823c9c13bb4e1f8d8b8d343447ff613ebd5759193ed20fe892" => :yosemite
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
