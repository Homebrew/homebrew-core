class Uffizzi < Formula
  desc "Manage virtual k8s clusters"
  homepage "https://uffizzi.com"
  url "https://github.com/UffizziCloud/uffizzi_cli/archive/refs/tags/v2.0.32.tar.gz"
  sha256 "aa904ea64fbd2b4f161b0498919bb48c6c9380de4063a1bae06446d3a8615d52"
  license "Apache-2.0"

  uses_from_macos "ruby"

  def install
    system "gem", "install", "uffizzi-cli", "-v", "2.0.32", "--no-document", "--install-dir", libexec
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    bin.install Dir["#{libexec}/bin/*"]

    bin.env_script_all_files(libexec, GEM_HOME: ENV["GEM_HOME"], GEM_PATH: ENV["GEM_PATH"])
  end

  test do
    output = shell_output("#{bin}/uffizzi version").strip
    expected_version = "2.0.32"

    if output == expected_version
      puts "The version matches #{expected_version}"
    else
      odie "Error: The version is #{output}, expected: #{expected_version}"
    end
  end
end
