class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://code.videolan.org/videolan/x264.git",
      revision: "b35605ace3ddf7c1a5d67a2eb553f034aef41d55"
  version "r3222"
  license "GPL-2.0-or-later"
  head "https://code.videolan.org/videolan/x264.git", branch: "master"

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

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b631667b5ad55c6c3ae383484f658c5b4ba14da8a2fbb1d537975695852529ca"
    sha256 cellar: :any,                 arm64_sequoia: "a613d44ead5d3999270970f41283eadfad8001061faf063945def6b8fb5145f4"
    sha256 cellar: :any,                 arm64_sonoma:  "6a932a218451e42a2678ea041e7453e7836249eb6b7013f8d2a3e8bfbb80a574"
    sha256 cellar: :any,                 arm64_ventura: "2f620df0464c5bce04ab31c0ad8a4c0ecc8a2684b94815b41795125ba3a62415"
    sha256 cellar: :any,                 sonoma:        "3a260293e96e74afe7c763841d42085092f66711b6cec8aa693a1458e26eae3a"
    sha256 cellar: :any,                 ventura:       "ae46d51d6cfe33e0af6dae3b8e71e622903f2cce96000abda646e5a37d0f2fb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebafe98d77b8826fcf5412762db4dfce34bb491e4bd658eedc25a1e49f18f040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ec18379e16e4e5fd740518dd8964472392725b10dcde1e726f02a34bcba813e"
  end

  on_intel do
    depends_on "nasm" => :build
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
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "-L#{lib}", "test.c", "-lx264", "-o", "test"
    system "./test"
  end
end
