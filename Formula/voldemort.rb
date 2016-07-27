class Voldemort < Formula
  desc "Distributed key-value storage system"
  homepage "http://www.project-voldemort.com/"
  url "https://github.com/voldemort/voldemort/archive/release-1.10.19-cutoff.tar.gz"
  sha256 "a4aa19783eb167ee0c744344048990c526ef4f04ede4c6aefbd421d3aa152c7e"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee8571aaa2c508e52a16ad822f6d63a672d599200a4d15bd29077d2f6cb4b5d7" => :el_capitan
    sha256 "67c47e4e8ca5c8cf2e40e68cca7bc8da552cf661a03d172675ad24401696d04f" => :yosemite
    sha256 "8445021cd8eb62c4ce5ae89c3810dccfdbd0441a1c48233ca17a34adc484a869" => :mavericks
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
