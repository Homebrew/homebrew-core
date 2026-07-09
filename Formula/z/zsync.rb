class Zsync < Formula
  desc "File transfer program"
  homepage "https://zsync.moria.org.uk/"
  url "https://zsync.moria.org.uk/download/zsync-0.7.2.tar.gz"
  sha256 "51a54a2bcf60311f108924b5f8795fb7a8eeeedd0b52f4f634842ea3470978a2"
  license "Artistic-2.0"
  head "https://github.com/cph6/zsync.git", branch: "master"

  livecheck do
    url "https://zsync.moria.org.uk/downloads"
    regex(/href=.*?zsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2cfa51dff3ded22fde01b7dfe046efad9929c3228dc3f05f7ea98f70b5babfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2cfa51dff3ded22fde01b7dfe046efad9929c3228dc3f05f7ea98f70b5babfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2cfa51dff3ded22fde01b7dfe046efad9929c3228dc3f05f7ea98f70b5babfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "74a2e931d6afbe5f3fa26404ded4c315aaf0f3e43c005c2d7dd4568101729df7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63e76167039ecb67b01cb528fb44f11071ed79a159f329dfcf5ca17158228f16"
    sha256 cellar: :any,                 x86_64_linux:  "4aede5f74cbfa704369228eae8d8a223485164569ad7ea07b235fb9a4cb1bad1"
  end

  depends_on "go" => :build

  def install
    (buildpath/"cmd").each_child(false) do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/cmd), "./cmd/#{cmd}"
      man1.install "man/#{cmd}.1"
    end
  end

  test do
    touch testpath/"foo"
    system bin/"zsyncmake", "foo"
    sha1 = "da39a3ee5e6b4b0d3255bfef95601890afd80709"
    assert_match "SHA-1: #{sha1}", (testpath/"foo.zsync").read
  end
end
