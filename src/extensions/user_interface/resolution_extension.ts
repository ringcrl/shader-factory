import { WebviewExtension } from '../webview_extension';

export class ResolutionExtension implements WebviewExtension {
  private currResolution: string;

  constructor(currResolution: string) {
    this.currResolution = currResolution;
  }

  public generateContent(): string {
    return `
      <div id="resolutions">
        比例：${this.currResolution}
      </div>
    `;
  }
}
