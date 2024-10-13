class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v12.3/snapraid-12.3.tar.gz"
  sha256 "1f27aba6e5db3929474da9c472fc4a3bc51d4a83aa5385af6b09afc9f68d6d44"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fc7a3ba8c9665b58985e41bd73b01247d1a62d0d966babd0ce1674dc71ade512"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4da7ec06ad641c8d25b350c67fb8a100e0fe6d1a539deb8bb189244bdff8cb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0685e224941fd715cdc9074113ed6f85e81523bd90d3b74ce7d6c67d1073e09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fb09589076aef618afe6cddd5f0801c9332e074cbfea5b41770b01c5d1b0230"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0b303ac35e773f6e1f7540ea4ece7f91f7d2943ab6fd251f644998637ba01eb"
    sha256 cellar: :any_skip_relocation, ventura:        "1a85343ba4048288a9e950883b7fa0eb5b6f0436fc90e0a0295b80fbc7b32c14"
    sha256 cellar: :any_skip_relocation, monterey:       "d7952a904318b1162fa61da0500fbd13930debd9dbc95818265c75768dfa5df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e375ce8b03bd4fc70b7bf52a2b64b4ee626e0b2946845d3874cc0a3e29875bb4"
  end

  head do
    url "https://github.com/amadvance/snapraid.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
