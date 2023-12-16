class RevancedCli < Formula
  desc "Command-line application to use ReVanced"
  homepage "https://revanced.app"
  url "https://github.com/ReVanced/revanced-cli/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "4a98678bb490aa5209ad8e68ea0c60f87fdb7d1354988c956b44cd885d77e9da"
  license "GPL-3.0-only"

  depends_on "openjdk@11" => :build
  depends_on "openjdk"

  def install
    system "./gradlew", "clean", "shadow", "--no-daemon"
    libexec.install "build/libs/revanced-cli-#{version}-all.jar"
    bin.write_jar_script libexec/"revanced-cli-#{version}-all.jar", "revanced"
  end

  def caveats
    <<~EOS
      Some patches may require integrations such as ReVanced Integrations. Supply them with the option --merge.
        For more information see https://github.com/ReVanced/revanced-cli/blob/main/docs/1_usage.md
    EOS
  end

  test do
    assert_equal "ReVanced CLI v#{version}\n", shell_output(bin/"revanced -V")
  end
end
