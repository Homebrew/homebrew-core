class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.11.0.tar.gz"
  sha256 "59ae661c8eb33d00f31d33d48a908261bb4b0e2d001e1f40e16b5855fe46103b"
  revision 1

  bottle do
    sha256 "1a50bf2d816439fe9345eba45ac4febdaa1fa902878fdc156cb7388544da710a" => :sierra
    sha256 "011ce782217c67c424188684598217dddcdd267fc2b9b0296f57e1fdbd4a1087" => :el_capitan
    sha256 "3303278dc6f4819aa5679357c95606830d86528b9c1d5e6b9911eefc82188d74" => :yosemite
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
