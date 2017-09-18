class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.17.0.tar.gz"
  sha256 "f009acc32f2b15fcb0d2267bde6f6de9b3445179003c979ba61a8836abdb78f9"
  revision 1

  bottle do
    sha256 "8d9787286fec6cb91a0cb5378b6b9bb44cf16e24f37457b79e2e011f2031df79" => :high_sierra
    sha256 "236293c8bfaad85c437de7693b784af6ad22b46efa83e61907702358dd5c88d3" => :sierra
    sha256 "e2b19206b8c50fb43e2befd3b459d77023ceb02ffd312a6c2de72101c054c409" => :el_capitan
    sha256 "187df0fc43a45de7bc38b98e156b59658609401d09c5ec4d7e878f11a2e454eb" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp"
  depends_on "luajit"

  # More info on https://gist.github.com/juniorz/9986999
  resource "sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    ENV.libcxx if MacOS.version < :mavericks

    mkdir "build" do
      system "cmake", "..", "-DSYSDIG_VERSION=#{version}",
                            "-DUSE_BUNDLED_DEPS=OFF",
                            *std_cmake_args
      system "make", "install"
    end

    (pkgshare/"demos").install resource("sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
