class S3m < Formula
  desc "CLI for streams of data in S3 buckets"
  homepage "https://s3m.stream/"
  url "https://github.com/s3m/s3m/archive/refs/tags/0.7.1.tar.gz"
  sha256 "06d8a9dfdf5d659fa08ea60b115517cf9c4142ffdcdb89a54c6adedc2f640617"
  license "BSD-3-Clause"
  head "https://github.com/s3m/s3m.git", branch: "main"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    cmd = "#{bin}/s3m show"
    output = `#{cmd} 2>&1`  # Redirect stderr to stdout to capture error messages
    assert_match(/^error: invalid value/, output)

    if OS.linux?
      [
        Formula["openssl@3"].opt_lib/shared_library("libssl"),
        Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      ].each do |library|
        assert check_binary_linkage(bin/"s3m", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
      end
    end
  end
end
