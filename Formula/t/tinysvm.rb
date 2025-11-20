class Tinysvm < Formula
  desc "Support vector machine library for pattern recognition"
  homepage "http://chasen.org/~taku/software/TinySVM/"
  url "http://chasen.org/~taku/software/TinySVM/src/TinySVM-0.09.tar.gz"
  sha256 "e377f7ede3e022247da31774a4f75f3595ce768bc1afe3de9fc8e962242c7ab8"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?TinySVM[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a2eb89bfd1881f7b67dce74b71a07303f8fb67833fb83d269f1a5546ef23250f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "abf56f8965d9604d945e925ce1d7fe4bb6dfe40a3290f7e60dd7308be6f7e211"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75db20d17ee9a60546200f1a0329d5f9c66ae6f162d7b821ac888a27016bfc79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d10346e2bcb343d454ce390ad8388b25b3fd0040e9d0d163cf34db818b3d124"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c2118088fe8eead47f050a218c6c7c5928f1c127cfebfb6652f845d5fa195fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bc765f1a83890ba72ab3ddd3b7c43d947b4f8e2aaac19807e7703c6ee58158b"
    sha256 cellar: :any_skip_relocation, sonoma:         "12ea52272fb0b0d6d7a3dbd64037a014c0c8be9c5c1f1d32b1ea89626bb76041"
    sha256 cellar: :any_skip_relocation, ventura:        "0fed16a29b53d89101342664aed44ff3c3341d012ff02ba3b17de3bec6e5ceda"
    sha256 cellar: :any_skip_relocation, monterey:       "06e39f32239001cf5191e4896a8c8714c598513769e08129c182f47aa7f47366"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ead575e862216b468d3f55c0b20789405f25e03667838da0fadeb0bd3931d37"
    sha256 cellar: :any_skip_relocation, catalina:       "5bbed1c1f653d0fde6a8e82740a18f8f0e4c95f6d06c7c14dd8dbd4ed096c758"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b94cad8abff9ac7cd69e6e0946255e477dba4c6038e1ff8609b9ea499c9d5e1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8706fa788fd556b7f18b3c1aee12390a933b5eafaa909508304d6992f218e02d"
  end

  # Use correct compilation flag, via MacPorts.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/tinysvm/patch-configure.diff"
    sha256 "b4cd84063fd56cdcb0212528c6d424788528a9d6b8b0a17aa01294773c62e8a7"
  end

  def install
    # Needed to select proper getopt, per MacPorts
    ENV.append_to_cflags "-D__GNU_LIBRARY__"

    # Fix for newer clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    args = []
    # Help old config scripts identify arm64 linux
    args << "--host=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--mandir=#{man}", "--disable-shared", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"train.svmdata").write <<~EOS
      +1 201:1.2 3148:1.8 3983:1 4882:1
      -1 874:0.3 3652:1.1 3963:1 6179:1
      +1 1168:1.2 3318:1.2 3938:1.8 4481:1
      +1 350:1 3082:1.5 3965:1 6122:0.2
      -1 99:1 3057:1 3957:1 5838:0.3
    EOS

    (testpath/"train.svrdata").write <<~EOS
      0.23 201:1.2 3148:1.8 3983:1 4882:1
      0.33 874:0.3 3652:1.1 3963:1 6179:1
      -0.12 1168:1.2 3318:1.2 3938:1.8 4481:1
    EOS

    system bin/"svm_learn", "-t", "1", "-d", "2", "-c", "train.svmdata", "test"
    system bin/"svm_classify", "-V", "train.svmdata", "test"
    system bin/"svm_model", "test"

    assert_path_exists testpath/"test"
  end
end
