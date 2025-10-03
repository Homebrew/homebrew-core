class Symlinks < Formula
  desc "Symbolic link maintenance utility"
  homepage "https://github.com/brandt/symlinks"
  url "https://github.com/brandt/symlinks/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "27105b2898f28fd53d52cb6fa77da1c1f3b38e6a0fc2a66bf8a25cd546cb30b2"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f8dc7f7f7a34aca2effa06e21560ea6828e1cb4cfba15d877010545735a9ce9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a4f0d8f94815e056e274db19ee924739711eb18bc11909a6ea5faecf74826fd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63775f3fb81a39f472e290b09fe8143ec432bbc19b800356e43b5314dc6d07a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9565d0513b291d25891ab6192c318104007b8a450ebb8cb0e0367eee6732e17d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be3cc7375c33600fc1bc7c4b9a4bc0987013738ae1b5986a40f12eb3ef47a31e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12782096332429fbdcb34f1c3efa2bb1a53271498a9ae54a1ff2b2fd2ba54ed1"
    sha256 cellar: :any_skip_relocation, sonoma:         "1826aa18c112a7209293d848271769bb1e055ba2ed30fa344f3f25cbba79a211"
    sha256 cellar: :any_skip_relocation, ventura:        "0efd028e16901e24ae61617b66099a2da58b5b1b0c7f24300b2d12b7e37c922b"
    sha256 cellar: :any_skip_relocation, monterey:       "bbf388e44afd53159ccc8918b7cf97605d2fd002cf80ce525bc76ea37cb13aeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f63fc62ca034e2d55e31d089c54dc65c4cd51a3caa0d58afe2da171482d66fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9775f41fa313f392bd41d105655066f62d1e76865fd0979654248ec94237b802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba93ffe41e5f1aa71ca91847cb66bbe80906efc78b8c1cf008ce312681aecb64"
  end

  def install
    system "make", "install"
    bin.install "symlinks"
    man8.install "symlinks.8"
  end

  test do
    assert_match "->", shell_output("#{bin}/symlinks -v #{__dir__}/../../Aliases")
  end
end
