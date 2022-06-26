class Tinysvm < Formula
  desc "Support vector machine library for pattern recognition"
  homepage "http://chasen.org/~taku/software/TinySVM/"
  url "http://chasen.org/~taku/software/TinySVM/src/TinySVM-0.09.tar.gz"
  sha256 "e377f7ede3e022247da31774a4f75f3595ce768bc1afe3de9fc8e962242c7ab8"
  license "LGPL-2.1"

  livecheck do
    url :homepage
    regex(/href=.*?TinySVM[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c2118088fe8eead47f050a218c6c7c5928f1c127cfebfb6652f845d5fa195fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bc765f1a83890ba72ab3ddd3b7c43d947b4f8e2aaac19807e7703c6ee58158b"
    sha256 cellar: :any_skip_relocation, monterey:       "06e39f32239001cf5191e4896a8c8714c598513769e08129c182f47aa7f47366"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ead575e862216b468d3f55c0b20789405f25e03667838da0fadeb0bd3931d37"
    sha256 cellar: :any_skip_relocation, catalina:       "5bbed1c1f653d0fde6a8e82740a18f8f0e4c95f6d06c7c14dd8dbd4ed096c758"
    sha256 cellar: :any_skip_relocation, mojave:         "56f1afa09c931eb7e8dfaf46f1a814c1df306e4c20269ef78fddfbdf85a7251a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "62f0920fdf8f5b7f29cebacc1add1396daef668c67e3d10644d9d35d1b49afc5"
    sha256 cellar: :any_skip_relocation, sierra:         "a6ad14c984b337bee83372ac6a29ffe7c0491180a302cfcd8f53b1a3ee6816e1"
    sha256 cellar: :any_skip_relocation, el_capitan:     "2b84b75043ba1d97172e2756e3da870a8ec8e074167ab5402e7a4e1b4c923864"
    sha256 cellar: :any_skip_relocation, yosemite:       "ea90446332244176d4ec3bc4ff0c6175810c3a39d942f225bb55c0fb6252858d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8706fa788fd556b7f18b3c1aee12390a933b5eafaa909508304d6992f218e02d"
  end

  # Use correct compilation flag, via MacPorts.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/838f605/tinysvm/patch-configure.diff"
    sha256 "b4cd84063fd56cdcb0212528c6d424788528a9d6b8b0a17aa01294773c62e8a7"
  end

  def install
    # Needed to select proper getopt, per MacPorts
    ENV.append_to_cflags "-D__GNU_LIBRARY__"

    inreplace "configure", "-O9", "" # clang barfs on -O9

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-shared"
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

    system "#{bin}/svm_learn", "-t", "1", "-d", "2", "-c", "train.svmdata", "test"
    system "#{bin}/svm_classify", "-V", "train.svmdata", "test"
    system "#{bin}/svm_model", "test"

    assert_predicate testpath/"test", :exist?
  end
end
