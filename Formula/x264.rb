class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  license "GPL-2.0-only"
  head "https://code.videolan.org/videolan/x264.git", branch: "master"

  stable do
    # the latest commit on the stable branch
    url "https://code.videolan.org/videolan/x264.git",
        revision: "baee400fa9ced6f5481a728138fed6e867b0ff7f"
    version "r3095"
  end

  # Cross-check the abbreviated commit hashes from the release filenames with
  # the latest commits in the `stable` Git branch:
  # https://code.videolan.org/videolan/x264/-/commits/stable
  livecheck do
    url "https://artifacts.videolan.org/x264/release-macos-arm64/"
    regex(%r{href=.*?x264[._-](r\d+)[._-]([\da-z]+)/?["' >]}i)
    strategy :page_match do |page, regex|
      # Match the version and abbreviated commit hash in filenames
      matches = page.scan(regex)

      # Fetch the `stable` Git branch Atom feed
      stable_page_data = Homebrew::Livecheck::Strategy.page_content("https://code.videolan.org/videolan/x264/-/commits/stable?format=atom")
      next if stable_page_data[:content].blank?

      # Extract commit hashes from the feed content
      commit_hashes = stable_page_data[:content].scan(%r{/commit/([\da-z]+)}i).flatten
      next if commit_hashes.blank?

      # Only keep versions with a matching commit hash in the `stable` branch
      matches.map do |match|
        release_hash = match[1]
        commit_in_stable = commit_hashes.any? do |commit_hash|
          commit_hash.start_with?(release_hash)
        end

        match[0] if commit_in_stable
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "723ef739ad0f22c6ae8fc19c0212135d470bbb53e3946c8b2efbb0203026b9a5"
    sha256 cellar: :any,                 arm64_big_sur:  "259e1196ad11c986c09dbda6bcb46f9eb34f5dbbee7b3f7f143f44c1867b0c1c"
    sha256 cellar: :any,                 monterey:       "76b53eea1fd91010a1dd1a3e8fdab21af559bfc6240869e81be6bf719b239dd6"
    sha256 cellar: :any,                 big_sur:        "98e1861b0c647c01a9138d8e4634b8bec00f9b9eb8a97302f14d3d240731715e"
    sha256 cellar: :any,                 catalina:       "915934596a3584dcae66bd6f439007e351ecce767a337aeaf6ac2d3ea5613446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac0f2d23ac3e1e91fec032d9712e6992d0b56c23d1c874caa31cfee067819a3e"
  end

  depends_on "nasm" => :build

  if MacOS.version <= :high_sierra
    # Stack realignment requires newer Clang
    # https://code.videolan.org/videolan/x264/-/commit/b5bc5d69c580429ff716bafcd43655e855c31b02
    depends_on "gcc"
    fails_with :clang
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-lsmash
      --disable-swscale
      --disable-ffms
      --enable-shared
      --enable-static
      --enable-strip
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s.delete("r"), shell_output("#{bin}/x264 --version").lines.first
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <x264.h>

      int main()
      {
          x264_picture_t pic;
          x264_picture_init(&pic);
          x264_picture_alloc(&pic, 1, 1, 1);
          x264_picture_clean(&pic);
          return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "test.c", "-lx264", "-o", "test"
    system "./test"
  end
end
