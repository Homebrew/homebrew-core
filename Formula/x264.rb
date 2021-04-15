class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  license "GPL-2.0-only"
  head "https://code.videolan.org/videolan/x264.git"

  stable do
    # the latest commit on the stable branch
    url "https://code.videolan.org/videolan/x264.git",
        revision: "b86ae3c66f51ac9eab5ab7ad09a9d62e67961b8a"
    version "r3048"
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
    sha256 cellar: :any, arm64_big_sur: "4f597c360dc023f6a9cd1bbe9b91e582dab095ba728a0f1456b604f0027e190e"
    sha256 cellar: :any, big_sur:       "c15ba7b15e08f8d58ae1913935994c49fbc7242aae36eb7346be493b164ffb6b"
    sha256 cellar: :any, catalina:      "2f3a1318610548a1eae131141dace544594da35d11753dfdd9dc3b6f81c08801"
    sha256 cellar: :any, mojave:        "6bd8fc9dd92ce4aad6071c0e7d2eac6ccf8a9971f5176901a3fff22dbf24198d"
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
