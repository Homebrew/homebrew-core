class Voldemort < Formula
  desc "Distributed key-value storage system"
  homepage "http://www.project-voldemort.com/"
  url "https://github.com/voldemort/voldemort/archive/release-1.10.21-cutoff.tar.gz"
  sha256 "1404c66dcc1dbd7d2ddf6b48e3e39fd1434c1e799e4de7c342e8eabee530e927"

  bottle do
    cellar :any_skip_relocation
    sha256 "67b5fdc7b290504e1194641d6f47ff8c1f521d67f0b360bdad668e437d52e0e9" => :el_capitan
    sha256 "1261b6ddaed604d338fe1de716c592dd95881419d46bfb78289c0d6e7717f824" => :yosemite
    sha256 "90f925a4ab0793e4b6e45b9663b0399bc77c33ac4cb7fe2b9f6c2199128ad35a" => :mavericks
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
