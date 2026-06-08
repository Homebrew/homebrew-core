class Zsync < Formula
  desc "File transfer program"
  homepage "https://zsync.moria.org.uk/"
  url "https://zsync.moria.org.uk/download/zsync-0.7.1.tar.gz"
  sha256 "f521437761d9d19b5ca351f7736f28543cfb8a37391bbdc5b49681403268ff89"
  license "Artistic-2.0"
  head "https://github.com/cph6/zsync.git", branch: "master"

  livecheck do
    url "https://zsync.moria.org.uk/downloads"
    regex(/href=.*?zsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb6952fc8a4fc3c5a17df80920b6994fc4576c5116ba8889afa42dd15a224d2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb6952fc8a4fc3c5a17df80920b6994fc4576c5116ba8889afa42dd15a224d2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb6952fc8a4fc3c5a17df80920b6994fc4576c5116ba8889afa42dd15a224d2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e925f3f807f6b214d77f3fce1734a9feeda9ca86bb6ddd7eeaef9df3145bfbc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73084d34de13ab274066e65240c9459ebe0281fa33e2c5806cc7e13b8355e101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2bd874f2efd2cccc4627cf9944a24899b6b04345f7616bb05b861ea0339bde4"
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
