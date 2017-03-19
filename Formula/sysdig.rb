class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.15.0.tar.gz"
  sha256 "824bfd44c89d60e56a5a7a81a505ec91b6afcb3fd3962bf5697a9afe7ebe5723"

  bottle do
    sha256 "9c592c5329f56f9381bcb6b7e24d37273d0eb495fb61aa9505ff5b3ef0fcd624" => :sierra
    sha256 "faf69e0c4a037b96eec79df1ee500289896767e274ddbfa4afa3fb67c80798ee" => :el_capitan
    sha256 "2f0f1382b82b4e2fdd71cc12b66e08c7a7abf0850c6e5cf27fd8317097163cc7" => :yosemite
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
