class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.20.0.tar.gz"
  sha256 "e1f7e824831a9b902f6df0e818c41bdfc21175398d58318d7892df9c601e7e96"

  bottle do
    sha256 "e4a6c6d3fdc2e2af66ef4a187dea9a1eef21726efffc6898d1489a1bcc4325b2" => :high_sierra
    sha256 "f860f82acc1405a29e181582ed1abf6daeb99623e6186dd90e20e20ef7b10cde" => :sierra
    sha256 "583116ada7e9981e62a776f8aa3aae66ac912e3a5c5b0da1f33da9dad98da520" => :el_capitan
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
