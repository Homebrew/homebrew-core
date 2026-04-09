class Wifitui < Formula
  desc "Fast featureful friendly wifi terminal UI"
  homepage "https://github.com/shazow/wifitui"
  url "https://github.com/shazow/wifitui/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "9d049ddba951d226648ae5778b8609102298aec085eb85aa60f712ef37cb1116"
  license "MIT"
  head "https://github.com/shazow/wifitui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08cb96f9816a12a7f354ed4bc24747d33a23f6f5648da12ee6faab04e4e52f09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08cb96f9816a12a7f354ed4bc24747d33a23f6f5648da12ee6faab04e4e52f09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08cb96f9816a12a7f354ed4bc24747d33a23f6f5648da12ee6faab04e4e52f09"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f1a517af3aa353b9834577d29f52de5bea24a003915b7a83d9816a01e2b1699"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "442ff3ec8ee46f09240452d30cafcf7b178d8bfb282af6cdc2c287ec5489495c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b37e00309667810eb7eec9f7222f2a83453acef012cce42685855d7fcab563ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wifitui --version")

    expected = if OS.mac?
      "no Wi-Fi interface found"
    else
      "error: dial unix /var/run/dbus/system_bus_socket: connect: no such file or directory"
    end

    assert_match expected, shell_output("#{bin}/wifitui show nonexistent_network_id 2>&1", 1)
  end
end
