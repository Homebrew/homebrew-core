class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.15.0.tar.gz"
  sha256 "824bfd44c89d60e56a5a7a81a505ec91b6afcb3fd3962bf5697a9afe7ebe5723"

  bottle do
    sha256 "fe7354d3ec57b7c479e61785a4e782e011557fce46fed43687e9763a6a5306f5" => :sierra
    sha256 "b00e2b5553e3090b1703d9bf108c226fbf1575f2d83c774f5f03b9c496ed1d7a" => :el_capitan
    sha256 "35d9e1856ac55730d2b1b5814403a6b794960cec46da54c208034727555125b4" => :yosemite
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
