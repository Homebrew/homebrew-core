class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "9e3266d825180367997e2d2b049e40d74a5d1044e882a14b682bba3780d4883b"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      # For basic usage info, see:
      # https://slumber.lucaspickering.me/book/getting_started.html
      # For all collection options, see:
      # https://slumber.lucaspickering.me/book/api/request_collection/index.html

      # Profiles are groups of data you can easily switch between. A common usage is
      # to define profiles for various environments of a REST service
      profiles:
        example:
          name: Example Profile
          data:
            host: https://httpbin.org
    YAML
  end
end
