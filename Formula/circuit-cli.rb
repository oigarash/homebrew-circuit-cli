class CircuitCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for Cisco Circuit (circuit.cisco.com)"
  homepage "https://gitlab-cxj.cisco.com/jtac-apps/circuit-cli"
  url "https://gitlab-cxj.cisco.com/jtac-apps/circuit-cli/-/archive/v0.3.0/circuit-cli-v0.3.0.tar.gz"
  sha256 ""
  license "MIT"

  depends_on "python@3.11"

  # Run: scripts/generate-homebrew-resources.sh to regenerate resource blocks
  # --- BEGIN RESOURCES ---
  # --- END RESOURCES ---

  def install
    virtualenv_install_with_resources
  end

  def post_install
    opoo <<~EOS
      Playwright browser is required for authentication.
      Run the following command after installation:

        #{HOMEBREW_PREFIX}/bin/playwright install chromium
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/circuit --version")
  end
end
