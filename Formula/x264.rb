class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  license "GPL-2.0-only"
  head "https://code.videolan.org/videolan/x264.git"

  stable do
    # the latest commit on the stable branch
    url "https://code.videolan.org/videolan/x264.git",
        revision: "55d517bc4569272a2c9a367a4106c234aba2ffbc"
    version "r3049"
  end

  # Cross-check the abbreviated commit hashes from the release filenames with
  # the latest commits in the `stable` Git branch:
  # https://code.videolan.org/videolan/x264/-/commits/stable
  livecheck do
    url "https://artifacts.videolan.org/x264/release-macos/"
    regex(%r{href=.*?x264[._-](r\d+)[._-]([\da-z]+)/?["' >]}i)
    strategy :page_match do |page, regex|
      # Match the version and abbreviated commit hash in filenames
      matches = page.scan(regex)

      # Fetch the `stable` Git branch Atom feed
      stable_page_data = Homebrew::Livecheck::Strategy.page_content("https://code.videolan.org/videolan/x264/-/commits/stable?format=atom")
      return [] if stable_page_data[:content] && stable_page_data[:content].empty?

      # Extract commit hashes from the feed content
      commit_hashes = stable_page_data[:content].scan(%r{/commit/([\da-z]+)}i).flatten
      return [] if commit_hashes.empty?

      # Only keep versions with a matching commit hash in the `stable` branch
      matches.map do |match|
        next nil unless match.length >= 2

        release_hash = match[1]
        commit_in_stable = false
        commit_hashes.each do |commit_hash|
          next unless commit_hash.start_with?(release_hash)

          commit_in_stable = true
          break
        end

        commit_in_stable ? match[0] : nil
      end.compact
    end
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "277e4c3771be77c6cc8629194b1af90144e118a70f30f9b388ed8fcc3b0bad3e"
    sha256 cellar: :any, big_sur:       "6d74cd3f80239d92ce03b3ebccd7fdd3033552ed5ac637214d2c7e13e2aac7cd"
    sha256 cellar: :any, catalina:      "e27bf38f83a8b23d3c73d85f3ccb0b5397dbb540a39b40634200c3077b0895f0"
    sha256 cellar: :any, mojave:        "ecb12ab474f372bb0c0c137d4623f31f6daa70011489631f507b914ed38296d3"
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
