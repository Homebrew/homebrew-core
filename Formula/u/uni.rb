class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "627a8aebe8d72bad5a462b8efc8b96dc96794b926b094de3f1e5b9965e44a678"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2998fd67a43c49f3236e66445de964059199ab4768d9fd38b60f3090192f8a03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "37e3831bc8e3e33e11bd120dba3ac8cca6d5514dcb99b001c9f5737c7bc0f1d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37e3831bc8e3e33e11bd120dba3ac8cca6d5514dcb99b001c9f5737c7bc0f1d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37e3831bc8e3e33e11bd120dba3ac8cca6d5514dcb99b001c9f5737c7bc0f1d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37e3831bc8e3e33e11bd120dba3ac8cca6d5514dcb99b001c9f5737c7bc0f1d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "e35a0f3bdaf6a9c3eeac5bfeb1041c2f1bc454cfc3f13be21e97081e77a33530"
    sha256 cellar: :any_skip_relocation, ventura:        "e35a0f3bdaf6a9c3eeac5bfeb1041c2f1bc454cfc3f13be21e97081e77a33530"
    sha256 cellar: :any_skip_relocation, monterey:       "e35a0f3bdaf6a9c3eeac5bfeb1041c2f1bc454cfc3f13be21e97081e77a33530"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8c1644a7b55d42d6d5745029d5f4d861702dd3c331f4d6dbca67606c2ea4afc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e806e0bf1993f45ab980bd2a01bd4ae1d00b60adc33449c5ec5fdb766c0eebc2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
