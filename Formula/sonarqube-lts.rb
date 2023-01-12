class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.8.0.63668.zip"
  sha256 "5898eea6176e777b2af5656618cf679d235cb895c383c2cbd0b7bbf852d0f632"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarqube.org/downloads/"
    regex(/SonarQube\s+v?\d+(?:\.\d+)+\s+LTS.*?href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.(?:zip|t)/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8216e77fa076368806c31b2dd9a7407cd9b56ac1c71c8f7d9d3e9300991294df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba2c787766ebc3353063d6587529ace383b8d3e1a2b3ad853d6d1603734fe89e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df64c44ab8dfaf70244a6dcb2fe439a34b963e2cc2018f3d5aa250ba8f054d24"
    sha256 cellar: :any_skip_relocation, ventura:        "2ae615b8a1b62dfdcbd9b0840831b03577292d6f1a5be112841b363a7158f7f1"
    sha256 cellar: :any_skip_relocation, monterey:       "d69dd0f8179bd50bc8a017868f0c4fdc4367a20d2d0821ce408995df13f5277f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bff3fa4e9c6cdf563a464d2c15bc4cf41b64e1bba6caa3bdd543b32be004c28"
    sha256 cellar: :any_skip_relocation, catalina:       "e779f6c1c826f9210c1cdab545e94965a9587a6630a7acd861e5114751d866cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc58a80f7dd387a6e05462def97df3db4e974427fc5a78c6809565ef162289c6"
  end

  depends_on "openjdk@17"

  conflicts_with "sonarqube", because: "both install the same binaries"

  def install
    # Delete native bin directories for other systems
    remove, keep = if OS.mac?
      ["linux", "macosx-universal"]
    else
      ["macosx", "linux-x86"]
    end

    rm_rf Dir["bin/{#{remove},windows}-*"]

    libexec.install Dir["*"]

    (bin/"sonar").write_env_script libexec/"bin/#{keep}-64/sonar.sh",
      Language::Java.overridable_java_home_env("17")
  end

  service do
    run [opt_bin/"sonar", "start"]
  end

  test do
    ENV["SONAR_JAVA_PATH"] = Formula["openjdk@17"].opt_bin/"java"
    assert_match "SonarQube", shell_output("#{bin}/sonar status", 1)
  end
end
